--罗罗娜的工作室
function c4212306.initial_effect(c)
	c:SetUniqueOnField(1,0,4212306)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c4212306.activate)
	c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c4212306.tg)
	e3:SetOperation(c4212306.op)
	c:RegisterEffect(e3)
end
function c4212306.mfilter(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c4212306.cfilter(c) 
	return c:IsAbleToHand()
end
function c4212306.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c4212306.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),95) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,c4212306.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e)
			if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
			if Duel.GetMatchingGroupCount(c4212306.mfilter,tp,LOCATION_SZONE,0,nil)>=3 then
				if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212306,1)) then
					local tc = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
					if tc:GetCount()>0 then
						Duel.Destroy(tc,REASON_EFFECT)
					end			
				end
			end
		end
	end
end
function c4212306.cdfilter(c,e,tp) 
	return c:IsSetCard(0xa25) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4212306.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212306.cdfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c4212306.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4212306.cdfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,4212301) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212306,2))
			and	e:GetHandler():IsAbleToHand() then
			local tc = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,4212301)
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
			end			
		end
	end
end