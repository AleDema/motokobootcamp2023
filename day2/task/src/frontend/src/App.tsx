import React, { useEffect, useState } from "react"
import logo from "./assets/dfinity.svg"
/*
 * Connect2ic provides essential utilities for IC app development
 */
import { createClient } from "@connect2ic/core"
import { defaultProviders } from "@connect2ic/core/providers"
import { Connect2ICProvider } from "@connect2ic/react"
import "@connect2ic/core/style.css"
/*
 * Import canister definitions like this:
 */
import * as declarations from "@declarations/DAO"
/*
 * Some examples to get you started
 */
import { Transfer } from "@components/Transfer"
import { Profile } from "@components/Profile"

import Home from '@pages/Home';
import ErrorPage from '@pages/ErrorPage';
import RootLayout from '@layouts/RootLayout';

//STATE
import { useSnapshot } from 'valtio'
import state from "@context/global"

//CANISTER
import { DAO } from "@declarations/DAO"

//ROUTING
import { createRoutesFromElements, Link } from "react-router-dom";
import {
  createBrowserRouter,
  RouterProvider,
  Route
} from "react-router-dom";

function App() {

  const snap = useSnapshot(state)

  const [count, setCount] = useState<bigint>()

  const refreshCounter = async () => {
    const freshCount = await DAO.getValue() as bigint
    setCount(freshCount)
  }

  const increment = async () => {
    //setCount(count++)
    await DAO.increment()
    await refreshCounter()
  }

  useEffect(() => {
    refreshCounter();
  }, [])

  return (
    <>
      <div>
        <img src={logo} className="logo h-28" alt="logo" />
      </div>
      <h1 className="text-5xl">Vite + React + ICP</h1>
      <div className="space-x-4">
        <button onClick={() => state.count++}>
          Valtio count is {snap.count}
        </button>
        <button onClick={increment}>
          Canister count is {count?.toString()}
        </button>
        <p className="text-center">
          Edit <code>App.jsx</code> and save to test HMR
        </p>
      </div>

      <Link to="/home">Link</Link>

      <div>
        <Profile />
        <Transfer />
      </div>
    </>

  )
}


const client = createClient({
  canisters: {
    declarations,
  },
  providers: defaultProviders,
  globalProviderConfig: {
    dev: import.meta.env.DEV,
  },
})


const router = createBrowserRouter(createRoutesFromElements(
  <Route path="/" element={<RootLayout />} errorElement={<ErrorPage />}>
    <Route index element={<App />} />
    <Route path="/home" element={<Home />} />
  </Route>
));

export default () => (
  <Connect2ICProvider client={client}>
    <RouterProvider router={router} />
  </Connect2ICProvider>
)
