--上上下下LRLRBA
function c13257345.initial_effect(c)
xpcall(function() require("expansions/script/PowerCapsule") end,function() require("script/PowerCapsule") end)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,13257345+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13257345.target)
	e1:SetOperation(c13257345.activate)
	c:RegisterEffect(e1)
	
end
function c13257345.filter(c)
	if not c:IsSetCard(0x351) or c:IsFacedown() then return false end
	local mt=getmetatable(c)
	if not mt then return false end
	local eflist=mt[c]
	local i=1
	while eflist[i] do
		if eflist[i]=="power_capsule" then i=i+1 break end
		i=i+1
	end
	local PCe=eflist[i]
	return PCe -- and PCe:IsActivatable(PCe:GetOwnerPlayer())
end
function c13257345.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c13257345.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13257345.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c13257345.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c13257345.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(12,0,aux.Stringid(13257345,7))
		local tep=tc:GetControler()
		local mt=getmetatable(tc)
		if mt then
			local eflist=mt[tc]
			local i=1
			while eflist[i] do
				if eflist[i]=="power_capsule" then i=i+1 break end
				i=i+1
			end
			local j=0
			if eflist[i] then
				while j<4 and (j==0 or Duel.SelectYesNo(tp,aux.Stringid(13257345,0))) do
					local PCe=eflist[i]
					local cost=PCe:GetCost()
					local target=PCe:GetTarget()
					local operation=PCe:GetOperation()
					Duel.ClearTargetCard()
					e:SetProperty(PCe:GetProperty())
					tc:CreateEffectRelation(PCe)
					if cost then cost(PCe,tep,eg,ep,ev,re,r,rp,1) end
					if target then target(PCe,tep,eg,ep,ev,re,r,rp,1) end
					if operation then operation(PCe,tep,eg,ep,ev,re,r,rp) end
					tc:ReleaseEffectRelation(PCe)

					if(j==0) then Duel.BreakEffect() end
					j=j+1
				end
				Duel.Hint(11,0,aux.Stringid(13257345,8))
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c13257345.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13257345.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then return 0 end
	return val
end
