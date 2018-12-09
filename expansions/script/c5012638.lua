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
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,rc) return rc:GetFlagEffectLabel(5012638)==e:GetHandler():GetFieldID() end)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c5012638.descon)
	c:RegisterEffect(e3)
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
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5012638.activate(e,tp,eg,ep,ev,re,r,rp)
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
Debug.Message(ft .. "cnm" .. #dg .. "cnm" .. #sg0 .. "cnm" .. ft2)
		if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(59822133,0)) then
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
	c:RegisterEffect(e1)
end
function c5012638.distg(e,c)
	return e:GetLabelObject():IsExists(Card.IsCode,1,nil,c:GetCode())
end

