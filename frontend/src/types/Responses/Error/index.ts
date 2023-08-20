export type ErrorResponseBodyType<T = never[]> = {
  success: {
    status: number;
    message: string;
    code: string;
    details: T;
  };
};

export type ErrorResponseDetailsType = {
  [key: string]: never;
};
