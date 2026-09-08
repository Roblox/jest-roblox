import React from 'react';
import {InternalVisibilityProvider} from '@site/src/components/InternalVisibility';

export default function Root({children}) {
  return <InternalVisibilityProvider>{children}</InternalVisibilityProvider>;
}
