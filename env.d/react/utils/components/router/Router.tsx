// import { memo, FC } from 'react';
// import { Route, Routes } from 'react-router-dom';

// export const Router: FC = memo(() => {
//   return (
//       <Routes>
//         <Route path="" element={} />
//       </Routes>
//   );
// });

/**
 * Switch & Route のパスのマッチルール
 *
 * その1:
 * Routeのpathは、階層の深い(具体性が高い)順に書く。
 * exactを付けると階層が浅い(抽象度が高い)順に書ける?
 *
 * その2:
 * 非正規表現でパスを書く場合はexactはfalseにする。
 * 非正規表現を含むパスでは、exactがfalseなので、階層が深い順でパスを並べる
 */
