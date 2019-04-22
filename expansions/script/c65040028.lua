--水天的空流
function c65040033.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--burst!!!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65040033.cost)
	e1:SetTarget(c65040033.tg)
	e1:SetOperation(c65040033.op)
	c:RegisterEffect(e1)
end
function c65040033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(65040033)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(65040033,RESET_CHAIN,0,1)
end
function c65040033.refil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c65040033.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65040033.refil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetChainLimit(c65040033.chlimit)
end
function c65040033.chlimit(e,ep,tp)
	return tp==ep
end
function c65040033.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetMatchingGroupCount(c65040033.refil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler())
	local g=Duel.SelectMatchingCard(tp,c65040033.refil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,num,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
	if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabelObject(tc)
	e1:SetCondition(c65040033.retcon)
	e1:SetOperation(c65040033.retop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	local atk=tc:GetBaseAttack()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e2:SetValue(atk)
	c:RegisterEffect(e2)
	tc=g:GetNext()
	end
	end
end
function c65040033.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnPlayer()==tp and tc:IsPreviousLocation(LOCATION_MZONE)
end
function c65040033.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end