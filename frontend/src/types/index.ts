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
export type UserResourceType = {
  data: {
    id: number;
  };
};

// get('/api/memos')のレスポンスの型
export type MemoResourceType = {
  data: {
    id: number;
    title: string;
    body: string;
  }[];
};
