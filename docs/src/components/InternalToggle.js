import React from 'react';
import clsx from 'clsx';
import {useInternalVisibility} from './InternalVisibility';
import styles from './InternalToggle.module.css';

export default function InternalToggle() {
  const {showInternal, setShowInternal} = useInternalVisibility();

  return (
    <button
      type="button"
      role="switch"
      aria-checked={showInternal}
      className={clsx(styles.control, showInternal && styles.checked)}
      title="Show sections that only apply inside Roblox"
      onClick={() => setShowInternal(!showInternal)}>
      <span className={styles.label}>Internal</span>
      <span className={styles.track} aria-hidden="true">
        <span className={styles.thumb} />
      </span>
    </button>
  );
}
