import { AxiosError, AxiosResponse } from "axios";
import { NextPage } from "next";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";

import { Loading } from "@/components/molecules";
import { Layout } from "@/components/templates";
import { useAuth } from "@/hooks";
import axios from "@/libs/axios";
import { UsersResourceType, UserType } from "@/types";

const UserPage: NextPage = () => {
  //* router
  const router = useRouter();

  //* local state
  const [users, setUsers] = useState<UserType[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  //* hooks
  const { checkLoggedIn } = useAuth();

  //* DidMount
  useEffect(() => {
    void (async () => {
      const res: boolean = await checkLoggedIn();
      if (!res) {
        await router.push("/");
        return;
      }

      await axios
        .get("/api/users")
        .then((res: AxiosResponse<UsersResourceType>) => {
          console.log(res.data);
          setUsers(res.data.data);
        })
        .catch((err: AxiosError) => {
          console.log(err.response);
        })
        .finally(() => {
          setIsLoading(false);
        });
    })();
  }, [router, checkLoggedIn, setIsLoading]);

  //* component
  if (isLoading) return <Loading />;

  //* JSX
  return (
    <Layout title="ユーザー一覧">
      <div className="mx-auto mt-32 w-2/3">
        <div className="mt-3">
          <div className="mx-auto grid w-2/3 grid-cols-2 gap-4  ">
            {users?.map((user: UserType, idx) => (
              <div className="mb-5 bg-gray-100 p-4 shadow-lg" key={idx.toString()}>
                <p className="mb-1 text-lg font-bold">{user.name}</p>
                <p className="">{user.email}</p>
                <p className="">{user.role}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default UserPage;
