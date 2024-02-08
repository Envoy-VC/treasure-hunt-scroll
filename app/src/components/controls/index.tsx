import React from 'react';

import {
  BarretenbergBackend,
  type CompiledCircuit,
} from '@noir-lang/backend_barretenberg';
import { Noir, keccak256 } from '@noir-lang/noir_js';

import circuits from '~/assets/circuits.json';

import { usePlayerStore } from '~/lib/stores';
import { questions, additionalQuestions, publicInputs } from '~/lib/data';

const Controls = () => {
  const { position } = usePlayerStore();

  const [value, setValue] = React.useState('');
  const [isProving, setIsProving] = React.useState(false);

  React.useEffect(() => {
    setValue('');
  }, [position]);

  const dig = async () => {
    if (!value) return;
    try {
      setIsProving(true);
      const circuit = circuits as CompiledCircuit;
      const backend = new BarretenbergBackend(circuit);
      const noir = new Noir(circuit, backend);
      await noir.init();

      const sol = new Uint8Array(Buffer.from(value));

      const input = {
        riddles: publicInputs,
        position: [position.x.toString(), position.y.toString()],
        answerHash: Array.from(keccak256(sol)),
      };

      const proof = await noir.generateFinalProof(input);
      console.log(proof);
      const verified = await noir.verifyFinalProof(proof);
      alert(verified ? 'Correct!' : 'Incorrect!');
    } catch (error) {
      console.log(error);
      alert('Error!');
    } finally {
      setIsProving(false);
    }
  };

  return (
    <div className='h-[960px] w-full px-4'>
      <div className='text-center text-3xl font-semibold'>ZK Treasure Hunt</div>
      <div className='my-12 flex flex-col items-center gap-4'>
        <span className='text-2xl font-semibold'>
          Current Position:
          <span className='font-medium'>{` ${position.x}`}</span>
          <span className='font-medium'>{`, ${position.y}`}</span>
        </span>
        <div className='flex flex-col gap-3'>
          <div className='text-lg font-medium'>Question:</div>
          {questions[`${position.x}x${position.y}`] ??
            additionalQuestions[
              Math.round(
                ((position.x + position.y) * 256) % additionalQuestions.length
              )
            ]}
          <input
            type='text'
            className='rounded-md border-2 border-gray-300 p-2'
            value={value}
            onChange={(e) => setValue(e.target.value)}
            disabled={isProving}
          />
        </div>
        <button
          className={`rounded-md bg-blue-500 p-2 px-5 text-white ${isProving && 'cursor-not-allowed bg-blue-400'}`}
          onClick={dig}
          disabled={isProving}
        >
          Dig
        </button>
      </div>
    </div>
  );
};

export default Controls;
