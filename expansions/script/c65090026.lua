--星之骑士拟身 阳伞
function c65090026.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090026)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_FISH),1,true,true)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65090026.tgcon1)
	e1:SetOperation(c65090026.tgop1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c65090026.op)
	c:RegisterEffect(e2)
end
function c65090026.op(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local rc=re:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g:IsContains(e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(65090026,0)) then
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			rc:CancelToGrave()
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
	end
end
function c65090026.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc==c or tc:GetControler()~=tp then return false end
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c65090026.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tf=re:GetTarget()
		local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
		if tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) then
			local g=Group.CreateGroup()
			g:AddCard(c)
			Duel.ChangeTargetCard(ev,g)
		end
	end
end