export type UserType = {
  name: string;
  email: string;
  role: string;
};

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
export type LoginValidationType = {
  email?: string;
  password?: string;
  loginFailed?: string;
};

export type LoginValidationResponseType = {
  errors: {
    [index: string]: string[];
  };
};

// POSTデータの型
export type MemoFormType = {
  title: string;
  body: string;
};

// バリデーションメッセージの型
export type MemoValidationType = {
  title?: string;
  body?: string;
};

export type MemoValidationResponseType = {
  errors: {
    [index: string]: string[];
  };
};

// post('/login')のレスポンスの型
export type UserResourceType = {
  data: {
    id: number;
  };
};

// get('api/users')のレスポンスの型
export type UsersResourceType = {
  data: {
    id: number;
    name: string;
    email: string;
    role: string;
  }[];
};

// get('/api/memos')のレスポンスの型
export type MemosResourceType = {
  data: {
    id: number;
    title: string;
    body: string;
  }[];
};
