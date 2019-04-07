--北上丽花的假日
require("expansions/script/c81000000")
function c81015038.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81015038)
	e1:SetTarget(c81015038.target)
	e1:SetOperation(c81015038.operation)
	c:RegisterEffect(e1)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81015938)
	e3:SetCondition(c81015038.tdcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c81015038.tdtg)
	e3:SetOperation(c81015038.tdop)
	c:RegisterEffect(e3)
end
function c81015038.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a)
end
function c81015038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81015038.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81015038.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81015038.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81015038.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(81015038,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81015038,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetLabelObject(tc)
		e1:SetCondition(c81015038.rmcon)
		e1:SetOperation(c81015038.rmop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81015038.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(81015038)~=0
end
function c81015038.rmfilter(c)
	return c:GetSequence()<5 and c:IsAbleToRemove()
end
function c81015038.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81015038.rmfilter,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_CARD,0,81015038)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local mg=g:Select(1-tp,2,2,nil)
	if mg:GetCount()>0 then
		Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
	end
end
function c81015038.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Tenka.ReikaCon(e) and aux.exccon(e)
end
function c81015038.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a) and c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81015038.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81015038.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81015038.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81015038.tdfilter,tp,LOCATION_GRAVE,0,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c81015038.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
