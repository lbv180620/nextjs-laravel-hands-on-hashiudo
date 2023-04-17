/* eslint @typescript-eslint/require-await: 0, @typescript-eslint/no-unused-vars: 0 */

import { PrismaAdapter } from "@next-auth/prisma-adapter";
import NextAuth, { NextAuthOptions } from "next-auth";
import GitHubProvider from "next-auth/providers/github";
import GoogleProvider from "next-auth/providers/google";

import prisma from "@/libs/prisma";

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(prisma),
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID || "",
      clientSecret: process.env.GOOGLE_CLIENT_SECRET || "",
    }),
    GitHubProvider({
      clientId: process.env.GITHUB_ID || "",
      clientSecret: process.env.GITHUB_SECRET || "",
    }),
  ],
  secret: process.env.SECRET,
  // session: {
  //   strategy: "database",
  //   maxAge: 60 * 60 * 24 * 30, // 30 days
  //   updateAge: 60 * 60 * 24, // 24 hours
  // },
  // useSecureCookies: process.env.NODE_ENV === "production",
  // pages: {
  //   signIn: "auth/signin",
  // },
  callbacks: {
    // async signIn() {
    //   console.log("サインイン");
    //   return true;
    // },
    async session({ session, user }) {
      // console.log(user);
      if (session?.user) {
        session.user.id = user.id;
        session.user.mobile = user.mobile;
      }
      // session.user.id = 1;
      // session.accessToken = token.accessToken;
      return session;
    },
    // async jwt({ token, account }) {
    //   console.log(`account: ${JSON.stringify(account)}`);
    //   if (account) token.accessToken = account.access_token;
    //   return token;
    // },
  },
  events: {
    createUser: async ({ user }) => {
      await prisma.user.update({
        where: {
          id: user.id,
        },
        data: {
          mobile: "090-1111-1111",
        },
      });
    },
  },
};

export default NextAuth(authOptions);
