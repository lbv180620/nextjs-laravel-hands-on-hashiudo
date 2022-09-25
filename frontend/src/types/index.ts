export type MemoType = {
  title: string;
  body: string;
};

// POSTデータの型
export type LoginFormType = {
  email: string;
  password: string;
};

// バリデーションメッセージの型
export type ValidationType = LoginFormType & { loginFailed: string };

// post('/login')のレスポンスの型
export type LoginResponseJsonType = {
  data: {
    id: number;
  };
};
