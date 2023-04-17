import { NextPage, InferGetServerSidePropsType, GetServerSidePropsContext, GetServerSideProps } from "next";
import { Session } from "next-auth";
import { getSession } from "next-auth/react";

type Props = InferGetServerSidePropsType<typeof getServerSideProps>;

const AboutPage: NextPage<Props> = ({ user }) => {
  return <h1>{user?.name}</h1>;
};

export const getServerSideProps: GetServerSideProps<{user: Session["user"]}> = async (ctx: GetServerSidePropsContext) => {
  const session = await getSession(ctx);

  if (!session) {
    return {
      redirect: {
        destination: "/",
        permanent: false,
      },
    };
  }

  const { user } = session;

  return {
    props: { user },
  };
};

export default AboutPage;
