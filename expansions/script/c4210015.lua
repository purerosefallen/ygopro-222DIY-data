--猫耳天堂-Chocola
function c4210015.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c4210015.splimit)
	c:RegisterEffect(e1)	
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210015,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(SUMMON_TYPE_SPECIAL)
	e2:SetCondition(c4210015.spcon)
	e2:SetOperation(c4210015.spop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210015,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)	
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c4210015.otcon)
	e3:SetTarget(c4210015.ottg)
	e3:SetOperation(c4210015.otop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,0xff)
	e4:SetValue(LOCATION_REMOVED)
	e4:SetCondition(function(e,c)return e:GetHandler():GetFlagEffect(4210015)~=0 end)
	e4:SetTarget(c4210015.rmtg)
	c:RegisterEffect(e4)	
end
function c4210015.spcfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x2af)
end
function c4210015.otcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4210015.spcfilter,1,nil,tp,rp)
end
function c4210015.ottg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:Filter(Card.IsAbleToDeck,nil,e):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c4210015.otop(e,tp,eg,ep,ev,re,r,rp)
	if eg:Filter(Card.IsAbleToHand,nil,e) then
		Duel.SendtoHand(eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,eg)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		if e:GetHandler():IsLocation(LOCATION_GRAVE) then
			Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		end	
	end
end
function c4210015.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x2af)
end
function c4210015.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x2af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4210015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c4210015.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c4210015.tgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4210015.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4210015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
	end
end
function c4210015.spfilter(c,tp)
	return c:IsFaceup() and c:GetFlagEffect(4210010)~=0 and c:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c4210015.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c4210015.spcon(e,c)	
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c4210015.spfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c4210015.mzfilter,ct,nil,tp))
end
function c4210015.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c4210015.spfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c4210015.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c4210015.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
	c:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
	c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210015,1))
	c:RegisterFlagEffect(4210015,RESET_EVENT+0xcff0000,0,0)
end
function c4210015.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end