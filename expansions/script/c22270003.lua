--S.T. 破碎之人
function c22270003.initial_effect(c)
	--ToHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270003,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,222700031)
	e1:SetCondition(c22270003.condition)
	e1:SetTarget(c22270003.target)
	e1:SetOperation(c22270003.operation)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c22270003.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22270003,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,222700032)
	e3:SetTarget(c22270003.sptg)
	e3:SetOperation(c22270003.spop)
	c:RegisterEffect(e3)
end
c22270003.named_with_ShouMetsu_ToShi=1
function c22270003.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270003.cfilter(c)
	return c22270003.IsShouMetsuToShi(c)
end
function c22270003.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc and rc:IsRace(RACE_MACHINE) and eg:IsExists(c22270003.cfilter,1,nil) and (re:GetCode()~=EFFECT_SPSUMMON_PROC or not rc:IsHasEffect(EFFECT_REVIVE_LIMIT))
end
function c22270003.filter1(c)
	return c22270003.IsShouMetsuToShi(c) and c:GetLevel()==2 and c:IsAbleToHand()
end
function c22270003.filter2(c)
	return c22270003.IsShouMetsuToShi(c) and c:GetLevel()==1 and c:IsAbleToHand()
end
function c22270003.filter(c)
	return c22270003.IsShouMetsuToShi(c) and c:IsLevelBelow(2) and c:IsAbleToHand()
end
function c22270003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroupCount(c22270003.filter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroupCount(c22270003.filter2,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return (g1>0 or g2>1) and e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,0,tp,LOCATION_GRAVE)
end
function c22270003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)<1 then return end
	local g2=Duel.GetMatchingGroupCount(c22270003.filter2,tp,LOCATION_GRAVE,0,nil)
	local g=Group.CreateGroup()
	local lv=2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if g2<2 then
		g=Duel.SelectMatchingCard(tp,c22270003.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	else
		g=Duel.SelectMatchingCard(tp,c22270003.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	end
	if g:GetCount()>0 then
		if lv-g:GetFirst():GetLevel()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g2=Duel.SelectMatchingCard(tp,c22270003.filter2,tp,LOCATION_GRAVE,0,1,1,g:GetFirst())
			if g2:GetCount()>0 then
				g:Merge(g2)
			end
		end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g:Filter(Card.IsLocation,nil,LOCATION_HAND))
	end
end
function c22270003.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		c:RegisterFlagEffect(22270003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
function c22270003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetFlagEffect(22270003)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22270003.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end