import React from 'react';

import { usePlayerStore, useAnimationStore } from '~/lib/stores';

interface Props {
  grid: number[][];
}
const useKeyboard = ({ grid }: Props) => {
  const { position, setPosition } = usePlayerStore();
  const { setCurrentAnimationState } = useAnimationStore();

  React.useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      const { key } = event;
      let newX = position.x;
      let newY = position.y;

      if (key === 'ArrowUp') {
        setCurrentAnimationState('run');
        newY = Math.max(0, position.y - 1);
      } else if (key === 'ArrowDown') {
        setCurrentAnimationState('run');
        newY = Math.min(grid.length - 1, position.y + 1);
      } else if (key === 'ArrowLeft') {
        setCurrentAnimationState('run');
        newX = Math.max(0, position.x - 1);
      } else if (key === 'ArrowRight') {
        setCurrentAnimationState('run');
        newX = Math.min(grid[0]!.length - 1, position.x + 1);
      } else {
        return;
      }

      setPosition({ x: newX, y: newY });
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [grid, position]);
};

export default useKeyboard;
