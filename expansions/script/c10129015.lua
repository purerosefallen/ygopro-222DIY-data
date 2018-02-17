--地狱鬼神 美洛厄尼斯
function c10129015.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c10129015.matfilter,1,1)
	c:EnableReviveLimit()
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10129015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10129015)
	e1:SetTarget(c10129015.sptg)
	e1:SetOperation(c10129015.spop)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(10129015)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
end
c10129015.outhell_fusion=true
function c10129015.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c10129015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10129015.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c10129015.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10129015.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   tc:RegisterEffect(e2)
	   local g=Duel.GetMatchingGroup(c10129015.thfilter,tp,LOCATION_DECK,0,nil,tc:GetCode())
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10129015,1)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
		  local tg=g:Select(tp,1,1,nil)
		  Duel.SendtoHand(tg,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg)  
	   end
	end
end
function c10129015.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c10129015.matfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1
end
