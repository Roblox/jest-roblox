import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from 'react';

const STORAGE_KEY = 'jestRoblox.showInternal';

const InternalVisibilityContext = createContext({
  showInternal: false,
  setShowInternal: () => {},
});

function readStoredPreference() {
  try {
    return window.localStorage.getItem(STORAGE_KEY) === 'true';
  } catch {
    // Storage access throws in some privacy modes; fall back to hidden.
    return false;
  }
}

export function InternalVisibilityProvider({children}) {
  // Always starts off so the server render and first client render agree.
  const [showInternal, setShowInternalState] = useState(false);

  useEffect(() => {
    setShowInternalState(readStoredPreference());
  }, []);

  const setShowInternal = useCallback((enabled) => {
    setShowInternalState(enabled);
    try {
      window.localStorage.setItem(STORAGE_KEY, String(enabled));
    } catch {
      // Preference is best-effort; the toggle still works for this session.
    }
  }, []);

  const value = useMemo(
    () => ({showInternal, setShowInternal}),
    [showInternal, setShowInternal],
  );

  return (
    <InternalVisibilityContext.Provider value={value}>
      {children}
    </InternalVisibilityContext.Provider>
  );
}

export function useInternalVisibility() {
  return useContext(InternalVisibilityContext);
}
