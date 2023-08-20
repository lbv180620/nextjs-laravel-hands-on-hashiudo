import { UserType } from "@/types/Entities";

export type LoginSuccessResponseDataType = UserType;

export type LogoutSuccessResponseDataType = never[];

export type LoginUserFetchSuccessResponseDataType = UserType;

export type RedirectUrlFetchSuccessDataType = {
  redirect_url: string;
};
