--龙棋兵团 骑兵队
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006003
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1,e2,e3=rsdcc.NormalMonsterFunction(c)
	local e4=rsdcc.QuickEffectFunction(c,m,nil,cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chk==0 then return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) end
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local seq=c:GetSequence()
	if seq>4 then return end
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
		flag=bit.bxor(flag,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
	end
end