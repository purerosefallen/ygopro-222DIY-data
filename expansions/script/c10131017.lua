--自由斗士-鹰眼的雪莉
function c10131017.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c10131017.linkfilter,2,2)
	c:EnableReviveLimit()  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10131017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10131017)
	e1:SetTarget(c10131017.target)
	e1:SetOperation(c10131017.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10131017.reptg)
	e2:SetValue(c10131017.repval)
	e2:SetOperation(c10131017.repop)
	c:RegisterEffect(e2)
end
function c10131017.linkfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_WARRIOR)
end
function c10131017.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x5338)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function c10131017.desfilter(c,e,tp)
	return c:IsControler(tp) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_DECK)) and c:IsSetCard(0x5338)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c10131017.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10131017.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c10131017.desfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) 
	end
	if Duel.SelectYesNo(tp,aux.Stringid(10131017,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c10131017.desfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c10131017.repval(e,c)
	return c10131017.repfilter(c,e:GetHandlerPlayer())
end
function c10131017.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c10131017.filter(c,e,tp,zone)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)))
end
function c10131017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10131017.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetLinkedZone()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c10131017.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	if zone<=0 then return end
	Duel.Hint(HINT_MESSAGE,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10131017.filter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,zone):GetFirst()
	if not tc then return end
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(10131017,1))) then
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	else
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tc)
	end
end
