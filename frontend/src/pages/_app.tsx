/* eslint @typescript-eslint/no-unsafe-assignment: 0 */

import "@styles/globals.css"
import { NextComponentType } from "next"
import { Session } from "next-auth"
import { SessionProvider } from "next-auth/react"
import { RecoilRoot } from "recoil"

import type { AppProps } from "next/app"

export type CustomAppProps = AppProps<{ session: Session }> & {
  Component: NextComponentType & { requireAuth?: boolean }
}

function MyApp({ Component, pageProps: { session, ...pageProps } }: CustomAppProps) {
  return (
    <SessionProvider session={session}>
      <RecoilRoot>
        <Component {...pageProps} />
      </RecoilRoot>
    </SessionProvider>
  )
}

export default MyApp
