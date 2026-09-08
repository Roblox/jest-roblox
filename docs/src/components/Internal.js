import React from 'react';
import {useInternalVisibility} from './InternalVisibility';
import styles from './Internal.module.css';

export default function Internal({children, label = 'Internal'}) {
  const {showInternal} = useInternalVisibility();

  if (!showInternal) {
    return null;
  }

  return (
    <aside className={styles.internal}>
      <span className={styles.label}>{label}</span>
      {children}
    </aside>
  );
}
