'use client'

import { FullMessageType } from "@/app/types";
import clsx from "clsx";
import { useSession } from "next-auth/react";

interface MessageBoxProps {
    data: FullMessageType;
    isLast?: boolean
}
const MessageBox: React.FC<MessageBoxProps> = ({
    data,
    isLast
}) => {
    const session = useSession();
    const isOwn = session?.data?.user?.email === data?.sender?.email;
    const seenList = (data.seen || [])
        .filter((user) => user.email != data?.sender?.email)
        .map((user) => user.name)
        .join(', ');
    const container = clsx(
        "flex gap-3 p-4",
        isOwn
    )
    //TODO
    return (
        <div>
            Message
        </div>
    )
}

export default MessageBox;