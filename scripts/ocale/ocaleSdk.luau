--!strict
--[[
	Quick and dirty SDK for the Luau Execution Sessions API thrown together for demo purposes.
	Modified from https://github.com/Roblox/project-build-tool-prototype/blob/master/lute/ocale/ocaleSdk.luau
]]
local net = require("@lute/net")
local json = require("@std/json")
local fs = require("@std/fs")
local task = require("@lute/task")

local DemoSDK = {}

export type BinaryInputResponse = { path: string, size: number, uploadUri: string }
function DemoSDK.createBinaryInput(apiKey: string, universeId: number, filePath: string): BinaryInputResponse
	local fileSize = #fs.readfiletostring(filePath)

	local response = net.request(
		`https://apis.roblox.com/cloud/v2/universes/{universeId}/luau-execution-session-task-binary-inputs`,
		{
			method = "POST",
			headers = { ["x-api-key"] = apiKey, ["content-type"] = "application/json" },
			body = json.serialize({ size = fileSize }),
		}
	)
	assert(response.ok, `{response.status} - {response.body}`)
	return json.deserialize(response.body) :: BinaryInputResponse
end

function DemoSDK.uploadBinaryFile(uploadUri: string, filePath: string)
	local response = net.request(uploadUri, {
		method = "PUT",
		headers = { ["content-type"] = "application/octet-stream" },
		body = fs.readfiletostring(filePath),
	})
	assert(response.ok, `{response.status} - {response.body}`)
end

type PlaceInfo = {
	universeId: number,
	placeId: number,
	placeVersion: number?,
}

function DemoSDK.uploadPlaceFile(filePath: string, placeInfo: PlaceInfo, apiKey: string)
	local url =
		`https://apis.roblox.com/universes/v1/{placeInfo.universeId}/places/{placeInfo.placeId}/versions?versionType=Saved`
	local response = net.request(url, {
		method = "POST",
		headers = {
			["x-api-key"] = apiKey,
			["content-type"] = "application/xml",
			["Accept"] = "application/json",
		},
		body = fs.readfiletostring(filePath),
	})
	assert(response.ok, `{response.status} - {response.body}`)
end

local function getCreateTaskPath(placeInfo: PlaceInfo): string
	local url = `https://apis.roblox.com/cloud/v2/universes/{placeInfo.universeId}/places/{placeInfo.placeId}/`
	if placeInfo.placeVersion then
		url ..= `versions/{placeInfo.placeVersion}/`
	end
	url ..= "luau-execution-session-tasks"

	return url
end

export type TaskResponse = {
	path: string,
	createTime: string,
	updateTime: string,
	user: string,
	state: string,
	script: string,
	timeout: string,
	error: {
		code: string,
		message: string,
	}?,
	output: {
		results: { any },
	},
	enableBinaryOutput: true,
	binaryInput: string?,
	binaryOutputUri: string?,
}
function DemoSDK.createTask(
	apiKey: string,
	placeInfo: PlaceInfo,
	scriptPath: string,
	binaryInputPath: string?,
	enableBinaryOutput: boolean?,
	timeout: string?
): TaskResponse
	local url = getCreateTaskPath(placeInfo)
	local response = net.request(url, {
		method = "POST",
		headers = { ["x-api-key"] = apiKey, ["content-type"] = "application/json" },
		body = json.serialize({
			script = fs.readfiletostring(scriptPath),
			binaryInput = binaryInputPath,
			enableBinaryOutput = enableBinaryOutput,
			timeout = timeout,
		}),
	})
	assert(response.ok, `{response.status} - {response.body}`)

	return json.deserialize(response.body) :: TaskResponse
end

function DemoSDK.pollTaskCompletion(
	apiKey: string,
	taskPath: string,
	pollMaxAttempts: number?,
	pollInterval: number?
): TaskResponse
	local attemptsRemaining = pollMaxAttempts or -1
	pollInterval = pollInterval or 2

	while attemptsRemaining ~= 0 do
		attemptsRemaining -= 1

		local response = net.request(`https://apis.roblox.com/cloud/v2/{taskPath}`, {
			method = "GET",
			headers = { ["x-api-key"] = apiKey },
		})
		assert(response.ok, `{response.status} - {response.body}`)
		local body = json.deserialize(response.body) :: TaskResponse
		if body.state ~= "PROCESSING" then
			return body
		end

		task.wait(pollInterval)
	end

	error("Task did not complete within the maximum number of attempts")
end

function DemoSDK.getBinaryOutput(binaryOutputUri: string): string
	local response = net.request(binaryOutputUri, {
		method = "GET",
	})
	assert(response.ok, `{response.status} - {response.body}`)
	return response.body
end

function DemoSDK.getTaskLogs(apiKey: string, taskPath: string): string
	local response = net.request(`https://apis.roblox.com/cloud/v2/{taskPath}/logs`, {
		method = "GET",
		headers = { ["x-api-key"] = apiKey },
	})
	assert(response.ok, `{response.status} - {response.body}`)

	local body = json.deserialize(response.body) :: any
	local logs = body.luauExecutionSessionTaskLogs[1].messages
	assert(logs, "Error downloading task logs")
	return logs
end

return DemoSDK
