import Axios from "axios";

// const axios = (baseURL: string) =>
//   Axios.create({
//     baseURL,
//     headers: {
//       'Content-Type': 'application/json', // POST, PUTでJSON形式のデータを渡す場合に指定
//       'X-Requested-With': 'XMLHttpRequest', // クロスオリジンと通信するなら必要
//     },
//     withCredentials: true, // キャッシュ有効
//   });

const axios = Axios.create({
  baseURL: "http://localhost:8080",
  // headers: {
  //   'Content-Type': 'application/json',
  //   'X-Requested-With': 'XMLHttpRequest',
  // },
  withCredentials: true,
});

export default axios;
