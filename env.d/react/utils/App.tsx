// import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
// import { ReactQueryDevtools } from "@tanstack/react-query-devtools";
// import { FC } from "react";
// import { HelmetProvider } from "react-helmet-async";
// import { BrowserRouter } from "react-router-dom";

// import "@/styles/App.css";
// import { Router } from "./components/router/Router";

// //* default query client
// const queryClient = new QueryClient({
//   defaultOptions: {
//     queries: {
//       // fetchに失敗した場合は3回までretryする設定を無効化
//       retry: false,
//       // ユーザーがブラウザ上のアプリにfocusを当てた時に自動的にfetchが走る設定を無効化
//       refetchOnWindowFocus: false,
//     },
//   },
// });

// const App: FC = () => {
//   return (
//     <QueryClientProvider client={queryClient}>
//       <BrowserRouter>
//         <HelmetProvider>
//           <Router />
//         </HelmetProvider>
//       </BrowserRouter>
//       {/* trueにするとサーバーを起動した時に自動的にDevToolsが立ち上がるようになる設定を無効化 */}
//       <ReactQueryDevtools initialIsOpen={false} />
//     </QueryClientProvider>
//   );
// };

// export default App;
