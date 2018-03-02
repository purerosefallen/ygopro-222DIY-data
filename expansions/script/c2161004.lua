--天狐族术士-莉莉诺
function c2161004.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,2161004)
	e1:SetCondition(c2161004.spcon)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,2161011)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c2161004.rmcon)
	e2:SetTarget(c2161004.rmtg)
	e2:SetOperation(c2161004.rmop)
	c:RegisterEffect(e2)
end
function c2161004.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c2161004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c2161004.filter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c2161004.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()~=tp
end
function c2161004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c2161004.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and Duel.Remove(sg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local tc=sg:GetFirst()
		while tc do
		tc:RegisterFlagEffect(2161004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c2161004.retcon)
		e1:SetOperation(c2161004.retop)
		Duel.RegisterEffect(e1,tp)
		tc=sg:GetNext()
		end
	end
end
function c2161004.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(2161004)~=0
end
function c2161004.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end