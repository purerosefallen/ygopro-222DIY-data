--诺伦的薇尔丹蒂
function c22230005.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22230005)
	e1:SetCost(c22230005.cost)
	e1:SetTarget(c22230005.target)
	e1:SetOperation(c22230005.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTarget(c22230005.reptg)
	e2:SetValue(c22230005.repval)
	e2:SetOperation(c22230005.repop)
	c:RegisterEffect(e2)
end
function c22230005.IsValhalla(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Valhalla
end
function c22230005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(22230005,0x1fe1000+RESET_CHAIN,0,1)
end
function c22230005.filter(c,e,tp)
	return c22230005.IsValhalla(c) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22230005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c22230005.filter(chkc) and chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c22230005.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22230005.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22230005.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0  then
		if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
			if e:GetHandler():GetFlagEffect(22230005)>0 then
				e:GetHandler():SetCardTarget(tc)		
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c22230005.repfilter(c,ec)
	return ec:GetFirstCardTarget()==c and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c22230005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and eg:IsExists(c22230005.repfilter,1,nil,c) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c22230005.repval(e,c)
	return c22230005.repfilter(c,e:GetHandler())
end
function c22230005.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_RETURN)
end