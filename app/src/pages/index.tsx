import React from 'react';

export const grid = Array.from({ length: 32 }, () =>
  Array.from({ length: 32 }, () => 0)
);

import { MapImage } from '~/assets';
import NextImage from 'next/image';

import { usePlayerStore, useAnimationStore } from '~/lib/stores';
import { useKeyboard } from '~/lib/hooks';
import { Controls } from '~/components';

export const CELL_SIZE = 30;

const Home = () => {
  const canvasRef = React.useRef<HTMLCanvasElement>(null);
  const { position } = usePlayerStore();
  const {
    state,
    idleSpriteSheet,
    runSpriteSheet,
    currentFrame,
    setCurrentAnimationState,
  } = useAnimationStore();

  useKeyboard({ grid });

  React.useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    for (let row = 0; row < grid.length; row++) {
      for (let col = 0; col < grid.at(row)!.length; col++) {
        const color = 'transparent';
        ctx.fillStyle = color;
        ctx.fillRect(col * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    }
  }, [grid, position]);

  // Draw Player
  React.useEffect(() => {
    if (!canvasRef.current) return;
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const playerX = position.x * CELL_SIZE;
    const playerY = position.y * CELL_SIZE;
    const sprite = state === 'run' ? runSpriteSheet : idleSpriteSheet;
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const image = new Image();
    image.src = sprite.image;

    image.onload = () => {
      const { framesPerRow, totalFrames } = sprite;
      const frameWidth = image.width / framesPerRow;
      const frameHeight = image.height / Math.ceil(totalFrames / framesPerRow);
      const frameIndex = currentFrame % totalFrames;
      const frameRow = Math.floor(frameIndex / framesPerRow);
      const frameCol = frameIndex % framesPerRow;
      const frameX = frameCol * frameWidth;
      const frameY = frameRow * frameHeight;
      ctx.drawImage(
        image,
        frameX,
        frameY,
        frameWidth,
        frameHeight,
        playerX,
        playerY,
        72,
        72
      );
    };
  }, [position, canvasRef, state]);

  React.useEffect(() => {
    if (state === 'run') {
      const prevPos = position;
      const interval = setInterval(() => {
        const currentPos = position;
        if (currentPos === prevPos) setCurrentAnimationState('idle');
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [state]);

  return (
    <div className='mx-auto flex h-screen max-w-screen-2xl flex-col items-center justify-between gap-4 lg:flex-row'>
      <div className='relative w-full'>
        <canvas
          ref={canvasRef}
          width={grid[0]!.length * CELL_SIZE}
          height={grid.length * CELL_SIZE}
          className='absolute z-[100]'
        />
        <NextImage
          src={MapImage}
          width={960}
          height={960}
          className='z-[1] aspect-square min-w-[960px] max-w-[960px] rounded-lg'
          alt='Map'
        />
      </div>
      <Controls />
    </div>
  );
};

export default Home;
