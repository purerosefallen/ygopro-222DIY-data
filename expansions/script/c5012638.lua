--大星霸祭 开幕
function c5012638.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5012638.target)
	e1:SetOperation(c5012638.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c5012638.aclimit)
	c:RegisterEffect(e2)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c5012638.adjustop)
	c:RegisterEffect(e3)
	--limit sp summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c5012638.distg2)
	c:RegisterEffect(e4)
end
function c5012638.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e) and rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsLocation(LOCATION_MZONE)
end
function c5012638.distg2(e,c)
	local f=function(rc,code)
		return rc:IsCode(code) and rc:IsFaceup()
	end
	return Duel.IsExistingMatchingCard(f,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c5012638.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local f=function(c)
		return c:IsCode(5012615) and c:IsAbleToHand()
	end
	if not Duel.IsEnvironment(5012615) then
		if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(f,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK,0,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c5012638.descon(e)
	return not Duel.IsEnvironment(5012615)
end
function c5012638.spfilter(c,e,tp)
	return (c:IsSetCard(0x250) or c:IsSetCard(0x23c)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5012638.cfilter(c)
	return (c:IsSetCard(0x250) or c:IsSetCard(0x23c)) and c:IsDiscardable()
end
function c5012638.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5012638.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c5012638.activate(e,tp,eg,ep,ev,re,r,rp)
	c5012638.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=Duel.SelectMatchingCard(tp,c5012638.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg1<=0 or Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) < Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local dg=Duel.GetMatchingGroup(c5012638.cfilter,tp,LOCATION_HAND,0,nil)
		local sg0=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_DECK,0,nil,e,0,tp,false,false)
		sg0:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		local ft2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=math.min(ft,1) end
		local ct=math.min(ft,#dg,#sg0,ft2)
		if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(5012638,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local ct2=Duel.DiscardHand(tp,c5012638.cfilter,1,ct,REASON_EFFECT,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=sg0:Select(tp,1,ct2,nil)
			if #sg2>0 and Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)~=0 then
				sg1:Merge(sg2)
			end
		end
	end  
	local fid=c:GetFieldID()
	for rc in aux.Next(sg1) do
		rc:RegisterFlagEffect(5012638,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	sg1:KeepAlive()
	e1:SetLabelObject(sg1)
	e1:SetTarget(c5012638.distg)
	--c:RegisterEffect(e1)
end
function c5012638.distg(e,c)
	return e:GetLabelObject():IsExists(Card.IsCode,1,nil,c:GetCode())
end

