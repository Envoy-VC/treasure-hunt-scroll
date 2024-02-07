import { create } from 'zustand';

import { IdleSprite, RunSprite } from '~/assets';

interface PlayerState {
  position: { x: number; y: number };
  setPosition: (position: { x: number; y: number }) => void;
}

export const usePlayerStore = create<PlayerState>((set) => ({
  position: { x: 0, y: 0 },
  setPosition: (position) => set({ position }),
}));

interface SpriteSheet {
  image: string;
  frameWidth: number;
  frameHeight: number;
  framesPerRow: number;
  totalFrames: number;
  frameDuration: number;
}

interface AnimationState {
  state: 'idle' | 'run';
  setCurrentAnimationState: (state: 'idle' | 'run') => void;
  currentFrame: number;
  setCurrentFrame: (frame: number) => void;
  idleSpriteSheet: SpriteSheet;
  runSpriteSheet: SpriteSheet;
}

export const useAnimationStore = create<AnimationState>((set) => ({
  state: 'idle',
  setCurrentAnimationState: (state) => set({ state }),
  currentFrame: 0,
  setCurrentFrame: (currentFrame) => set({ currentFrame }),
  idleSpriteSheet: {
    image: IdleSprite.src,
    frameWidth: 64,
    frameHeight: 64,
    framesPerRow: 6,
    totalFrames: 6,
    frameDuration: 100,
  },
  runSpriteSheet: {
    image: RunSprite.src,
    frameWidth: 64,
    frameHeight: 64,
    framesPerRow: 8,
    totalFrames: 8,
    frameDuration: 100,
  },
}));
