--菲莉丝的工作室 
function c4212317.initial_effect(c)
	c:SetUniqueOnField(1,0,4212317)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c4212317.activate)
	c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(4212317,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c4212317.con)
    e3:SetTarget(c4212317.tg)
    e3:SetOperation(c4212317.op)
    c:RegisterEffect(e3)
end
function c4212317.mfilter(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c4212317.cfilter(c) 
	return c:IsSetCard(0x2a5) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c4212317.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c4212317.cfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),507) then
			local g=Duel.SelectMatchingCard(tp,c4212317.cfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler(),e)
			if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then
				 Duel.Draw(tp,1,REASON_EFFECT)
			end
			if Duel.GetMatchingGroupCount(c4212317.mfilter,tp,LOCATION_SZONE,0,nil)>=3 
				and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),TYPE_MONSTER) then
				if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212317,1)) then
					local tc = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),TYPE_MONSTER)
					if tc:GetCount()>0 then
						Duel.Destroy(tc,REASON_EFFECT)
					end			
				end
			end
		end
	end
end
function c4212317.cdfilter(c,e,tp) 
	return c:IsSetCard(0x2a5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4212317.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c4212317.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212307.cdfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c4212317.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4212317.cdfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end