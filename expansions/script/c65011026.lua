--阴影祈祀
function c65011026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65011026.tg)
	e1:SetOperation(c65011026.op)
	c:RegisterEffect(e1)
end
function c65011026.fil1(c)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsType(TYPE_TUNER) and Duel.IsExistingTarget(c65011026.fil2,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c65011026.fil2(c,lv)
	return c:IsFaceup() and c:GetLevel()>lv and not c:IsType(TYPE_TUNER)
end
function c65011026.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c65011026.fil1,tp,LOCATION_MZONE,0,1,nil) end
	local g1=Duel.SelectTarget(tp,c65011026.fil1,tp,LOCATION_MZONE,0,1,1,nil)
	local lv=g1:GetFirst():GetLevel()
	local g2=Duel.SelectTarget(tp,c65011026.fil2,tp,LOCATION_MZONE,0,1,1,nil,lv)
end
function c65011026.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local gc1=g:Filter(Card.IsType,nil,TYPE_TUNER):GetFirst()
	g:RemoveCard(gc1)
	local gc2=g:GetFirst()
	if gc1 and gc2 and not gc2:IsType(TYPE_TUNER) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		gc2:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		gc1:RegisterEffect(e1)
	end
end