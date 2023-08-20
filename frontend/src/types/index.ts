// エンティティ

export type UserType = {
  id: number;
  name: string;
  email: string;
};

export type MemoType = {
  id: number;
  title: string;
  body: string;
};

// ----------------------------------------------------------

// リクエスト

export type LoginRequestDataType = {
  email: string;
  password: string;
};

export type MemoCreateRequestType = {
  title: string;
  body: string;
};

// ----------------------------------------------------------

// バリデーション

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

// ----------------------------------------------------------

// レスポンス

export type ErrorResponseBodyType<T = never[]> = {
  success: {
    status: number;
    url: string;
    message: string;
    code: string;
    details: T;
  };
};

export type ErrorResponseDetailsType = {
  [key: string]: never;
};

export type SuccessResponseBodyType<T = never[]> = {
  success: {
    status: number;
    message: string;
    code: string;
    data: T;
  };
};

export type LoginSuccessResponseDataType = UserType;

export type LogoutSuccessResponseDataType = never[];

export type LoginUserFetchSuccessResponseDataType = UserType;

export type RedirectUrlFetchSuccessDataType = {
  redirect_url: string;
};

export type MemoListFetchSuccessResponseDataType = MemoType[];
