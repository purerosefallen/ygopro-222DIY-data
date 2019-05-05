--元始飞球
function c13254059.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254059.sprcon)
	e2:SetOperation(c13254059.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,13254059)
	e3:SetTarget(c13254059.smtg)
	e3:SetOperation(c13254059.smop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetCountLimit(1,23254059)
	e4:SetTarget(c13254059.reptg)
	e4:SetValue(c13254059.repval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e5)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--Tama Start
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e100:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	e100:SetRange(LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY)
	e100:SetCountLimit(1)
	e100:SetOperation(c13254059.start)
	c:RegisterEffect(e100)
	--Tama Advantage
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e101:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e101:SetCode(EVENT_ADJUST)
	e101:SetRange(LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY)
	e101:SetOperation(c13254059.advantage)
	c:RegisterEffect(e101)
	--Tama Counter
	local e102=Effect.CreateEffect(c)
	e102:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e102:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e102:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	e102:SetRange(LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY)
	e102:SetCountLimit(1)
	e102:SetOperation(c13254059.counter)
	c:RegisterEffect(e102)
	
end
function c13254059.spfilter(c)
	return c:IsSetCard(0x3356) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and not c:IsCode(13254059) and c:IsType(TYPE_MONSTER)
end
function c13254059.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<1 then
		res=mg:IsExists(c13254059.fselect,1,sg,tp,mg,sg)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
	sg:RemoveCard(c)
	return res
end
function c13254059.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254059.spfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254059.fselect,1,nil,tp,mg,sg)
end
function c13254059.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254059.spfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<1 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,c13254059.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end
function c13254059.smfilter(c)
	return c:IsSetCard(0x3356) and c:IsSummonable(true,nil)
end
function c13254059.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13254059.smfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c13254059.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c13254059.smfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c13254059.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3356)
		and c:IsAbleToHand()
end
function c13254059.repfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsType(TYPE_MONSTER) and c:IsCode(13254059)
		and c:IsAbleToHand()
end
function c13254059.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and eg:IsExists(c13254059.repfilter,1,nil,tp) and not eg:IsExists(c13254059.repfilter2,1,nil,tp) and e:GetHandler():IsAbleToExtra() end
	if Duel.SelectYesNo(tp,aux.Stringid(13254059,1)) then
		local g=eg:Filter(c13254059.repfilter,e:GetHandler(),tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,1,nil)
		end
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_DECK_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(13254059,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(c13254059.thcon)
		e1:SetOperation(c13254059.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_EFFECT)
		return true
	else return false end
end
function c13254059.repval(e,c)
	return false
end
function c13254059.thfilter(c)
	return c:GetFlagEffect(13254059)~=0
end
function c13254059.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13254059.thfilter,1,nil)
end
function c13254059.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13254059.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

function c13254059.start(e,tp,eg,ep,ev,re,r,rp,c)
	local realtp=e:GetHandler():GetOwner()
	if Duel.GetTurnPlayer()==realtp and Duel.GetFlagEffect(realtp,23254059)==0 then
		Duel.Hint(11,0,aux.Stringid(13254059,4))
		Duel.RegisterFlagEffect(realtp,23254059,0,0,0)
	end
end
function c13254059.advantage_filter(c)
	return c:IsLevelAbove(2) or c:IsLinkAbove(2)
end
function c13254059.advantage(e,tp,eg,ep,ev,re,r,rp,c)
	local realtp=e:GetHandler():GetOwner()
	if Duel.GetTurnPlayer()==realtp and Duel.GetCurrentPhase()>=PHASE_MAIN1 and (Duel.GetMatchingGroupCount(Card.IsSetCard,realtp,LOCATION_ONFIELD,0,nil,0x356)>=Duel.GetFieldGroupCount(1-realtp,LOCATION_ONFIELD) and Duel.GetMatchingGroupCount(c13254059.advantage_filter,realtp,LOCATION_MZONE,0,nil)>=2) and Duel.GetFlagEffect(realtp,33254059)==0 then
		Duel.Hint(11,0,aux.Stringid(13254059,5))
		Duel.RegisterFlagEffect(realtp,33254059,RESET_PHASE+PHASE_END,0,1)
	end
end
function c13254059.counter(e,tp,eg,ep,ev,re,r,rp,c)
	local realtp=e:GetHandler():GetOwner()
	if Duel.GetTurnPlayer()==realtp and Duel.GetCurrentPhase()>=PHASE_MAIN1 and Duel.GetFieldGroupCount(realtp,LOCATION_HAND+LOCATION_ONFIELD)<=Duel.GetFieldGroupCount(1-realtp,LOCATION_HAND+LOCATION_ONFIELD)+6 and Duel.GetFieldGroupCount(1-realtp,LOCATION_ONFIELD)>0 and Duel.GetFlagEffect(realtp,33254059)==0 then
		Duel.RegisterFlagEffect(realtp,33254059,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(c13254059.counter_avtivate)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c13254059.counter_avtivate(e,tp,eg,ep,ev,re,r,rp,c)
	local realtp=e:GetHandler():GetOwner()
	if Duel.GetTurnPlayer()==realtp and Duel.GetCurrentPhase()>=PHASE_MAIN1 and (Duel.GetMatchingGroupCount(Card.IsSetCard,realtp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,0x356)>=Duel.GetFieldGroupCount(1-realtp,LOCATION_HAND+LOCATION_ONFIELD) or Duel.GetFieldGroupCount(1-realtp,LOCATION_ONFIELD)==0) and  Duel.GetFlagEffect(realtp,33254059)>0 and Duel.GetFlagEffect(realtp,43254059)==0 then
		Duel.Hint(11,0,aux.Stringid(13254059,6))
		Duel.RegisterFlagEffect(realtp,43254059,RESET_PHASE+PHASE_END,0,1)
	end
end
