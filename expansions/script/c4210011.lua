--猫耳天堂-Azuki
function c4210011.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c4210011.splimit)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210011,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(SUMMON_TYPE_SPECIAL)
	e2:SetCondition(c4210011.spcon)
	e2:SetOperation(c4210011.spop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210011,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)	
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c4210011.ottg)
	e3:SetOperation(c4210011.otop)
	c:RegisterEffect(e3)	
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4210011,2))
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetCountLimit(1)
	e4:SetCondition(c4210011.condition)
	e4:SetTarget(c4210011.target)
	e4:SetOperation(c4210011.operation)
	c:RegisterEffect(e4)
end
function c4210011.spcfilter(c,e,tp)
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:GetSummonPlayer()==tp
end
function c4210011.ottg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c4210011.spcfilter,1,nil,e,tp) end
	local g=eg:Filter(c4210011.spcfilter,nil,e,tp)
end
function c4210011.otop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c4210011.atktg)
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end	
end
function c4210011.atktg(e,c)
	return c:IsSetCard(0x2af)
end
function c4210011.tgfilter(c,e,tp)
	return c:IsSetCard(0x2af) and c:IsAbleToHand()
end
function c4210011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210011.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c4210011.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
	local g=Duel.SelectMatchingCard(tp,c4210011.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c4210011.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x2af)
end
function c4210011.spfilter(c,tp)
	return c:IsFaceup() and c:GetFlagEffect(4210010)~=0 and c:IsControler(tp) and c:IsReleasable()
end
function c4210011.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c4210011.spcon(e,c)	
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c4210011.spfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c4210011.mzfilter,ct,nil,tp))
end
function c4210011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c4210011.spfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c4210011.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c4210011.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
	c:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
	c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210011,1))
	c:RegisterFlagEffect(4210011,RESET_EVENT+0xcff0000,0,0)
end
function c4210011.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():GetFlagEffect(4210011)~=0
end
function c4210011.filter(c)
	return c:IsSetCard(0x2af)
end
function c4210011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210011.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c4210011.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c4210011.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end