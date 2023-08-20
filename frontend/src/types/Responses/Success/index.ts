export type SuccessResponseBodyType<T = never[]> = {
  success: {
    status: number;
    message: string;
    code: string;
    data: T;
  };
};
