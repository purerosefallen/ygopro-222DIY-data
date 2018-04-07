--异界与心的朝花 茧墨阿座化
function c22260166.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c22260166.mfilter),2)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(c22260166.sprop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22260166,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetTarget(c22260166.sptg)
	e1:SetOperation(c22260166.spop)
	c:RegisterEffect(e1)
	--leavefield
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22260166,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetTarget(c22260166.lftg)
	e2:SetOperation(c22260166.lfop)
	c:RegisterEffect(e2)
end
function c22260166.mfilter(c,lc)
	return c:GetBaseAttack()==0 and c:IsCanBeLinkMaterial(lc)
end
function c22260166.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22260166.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c22260166.splimit(e,c)
	return c:GetBaseAttack()~=0
end
function c22260166.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=e:GetHandler():GetLinkedGroup()
	local ft=Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,zone)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK,zone)end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end 
function c22260166.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=e:GetHandler():GetLinkedGroup()
	local ft=Duel.GetMZoneCount(tp,g,tp,LOCATION_REASON_TOFIELD,zone)
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK,zone) then return end
	for i=1,ft do
		local token=Duel.CreateToken(tp,22269998)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	Duel.SpecialSummonComplete()
end

function c22260166.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c:IsFaceup()
end
function c22260166.lftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c22260166.thfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22260166.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c22260166.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,g:GetFirst():GetLocation())
end
function c22260166.lfop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c22260166.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c22260166.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler()==tc and not re:GetHandler():IsImmuneToEffect(e)
end