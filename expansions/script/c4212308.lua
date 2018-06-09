--梅露露的工作室
function c4212308.initial_effect(c)
	c:SetUniqueOnField(1,0,4212308)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c4212308.target)
	e2:SetOperation(c4212308.activate)
	c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c4212308.tg)
	e3:SetOperation(c4212308.op)
	c:RegisterEffect(e3)
end
function c4212308.mfilter(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c4212308.cfilter(c) 
	return c:IsType(TYPE_MONSTER)
end
function c4212308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212308.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c4212308.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c4212308.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	if Duel.GetMatchingGroupCount(c4212308.mfilter,tp,LOCATION_SZONE,0,nil)>=3 then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212308,1)) then
			local tc = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
			if tc:GetCount()>0 then
				Duel.Destroy(tc,REASON_EFFECT)
			end			
		end
	end
end
function c4212308.cdfilter(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x2a5) and not c:IsCode(4212308)
end
function c4212308.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212308.cdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c4212308.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4212308.cdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,4212305) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212308,2))
			and	e:GetHandler():IsAbleToHand() then
			local tc = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,4212305)
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
			end			
		end
	end
end