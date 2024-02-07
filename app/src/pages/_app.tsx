import React from 'react';

import { type AppType } from 'next/dist/shared/lib/utils';
import { Inter } from 'next/font/google';
const inter = Inter({ subsets: ['latin'] });

import '~/styles/globals.css';

const MyApp: AppType = ({ Component, pageProps }) => {
  const [mounted, setMounted] = React.useState(false);
  React.useEffect(() => {
    setMounted(true);
  }, []);
  if (mounted)
    return (
      <main className={inter.className}>
        <Component {...pageProps} />
      </main>
    );
};

export default MyApp;
