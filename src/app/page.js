import Image from 'next/image'

export default function Home() {
  return (
    <div className="bg-[#1012124D] flex flex-col items-center justify-center min-h-screen ">

      <h1 className="text-5xl font-normal text-center text-gray mb-2">
        Awo Staking Dapp
      </h1>
      <div>
        <p className='pt-4 text-2xl flex items-center justify-center '> stake your token </p>
      </div>
      <div className='pt-4 flex items-center justify-center'>
        <button className="bg-pink-500 hover:bg-pink-600 text-white font-bold py-4 px-8 rounded-full shadow-lg ">
          Get Details
        </button>

      </div>

    </div>
  )
}
