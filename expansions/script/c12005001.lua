--真神的末裔 丘依儿
function c12005001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005001,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12005001+EFFECT_COUNT_CODE_DUEL)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c12005001.thcon)
	e1:SetTarget(c12005001.thtg)
	e1:SetOperation(c12005001.thop)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12005001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
        e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12005101+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c12005001.target)
	e2:SetOperation(c12005001.operation)
	c:RegisterEffect(e2)  
end
function c12005001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbb) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c12005001.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:GetLink()==2 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) 
end
function c12005001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12005001.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c12005001.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c12005001.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12005001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()<=0 then return end
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(c12005001.spfilter,nil,e,tp)
	if tc:IsRelateToEffect(e) and tc:IsAbleToExtra() and Duel.GetLocationCountFromEx(tp,tp,tc)>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12005001,2)) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
	  local sg2=sg:RandomSelect(tp,1)
	  Duel.SpecialSummon(sg2,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	  sg2:GetFirst():CompleteProcedure()
	end
end
function c12005001.thfilter1(c)
	return c:IsSetCard(0xfbc) and c:IsAbleToHand()
end
function c12005001.thfilter2(c)
	return c:IsSetCard(0xfbb) and c:IsAbleToHand()
end
function c12005001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c12005001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(c12005001.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c12005001.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,c,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c12005001.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)<=0 or not Duel.IsExistingMatchingCard(c12005001.thfilter1,tp,LOCATION_DECK,0,1,nil) or not Duel.IsExistingMatchingCard(c12005001.thfilter2,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c12005001.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c12005001.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	local fid=c:GetFieldID()
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	for tc in aux.Next(g1) do
		tc:RegisterFlagEffect(12005001,RESET_EVENT+0x1fe0000,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
		g1:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g1)
		e1:SetCondition(c12005001.tgcon)
		e1:SetOperation(c12005001.tgop)
		Duel.RegisterEffect(e1,tp)
end
function c12005001.rmfilter(c,fid)
	return c:GetFlagEffectLabel(12005001)==fid
end
function c12005001.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c12005001.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c12005001.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c12005001.rmfilter,nil,e:GetLabel())
	Duel.SendtoGrave(tg,REASON_EFFECT)
end

