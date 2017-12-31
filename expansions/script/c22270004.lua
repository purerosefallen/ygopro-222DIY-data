--S.T. 武装赌徒
function c22270004.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_COIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22270004)
	e1:SetCondition(c22270004.spcon)
	e1:SetTarget(c22270004.sptg)
	e1:SetOperation(c22270004.spop)
	c:RegisterEffect(e1)
end
c22270004.named_with_ShouMetsu_ToShi=1
function c22270004.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270004.filterx(c)
	return c22270004.IsShouMetsuToShi(c) and c:IsRace(RACE_MACHINE)
end
function c22270004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22270004.filterx,1,nil)
end
function c22270004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c22270004.filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and c:IsFaceup()
end
function c22270004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local coin=Duel.TossCoin(tp,1)
		if coin==1 and Duel.IsExistingMatchingCard(c22270004.filter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22270004,1)) then 
			local g=Duel.SelectMatchingCard(tp,c22270004.filter,tp,LOCATION_REMOVED,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				if g:GetFirst():IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,g) end
			end
		else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCountLimit(1)
			e3:SetCondition(c22270004.descon)
			e3:SetOperation(c22270004.desop)
			e3:SetLabelObject(c)
			Duel.RegisterEffect(e3,tp)
			c:RegisterFlagEffect(22270004,RESET_EVENT+0x1fe0000,0,1)
		end
	end
end
function c22270004.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(22270004)==0 then
		e:Reset()
		return false
	end
	return true
end
function c22270004.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
end