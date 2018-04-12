--战争机器集结
function c13257213.initial_effect(c)
	c:SetUniqueOnField(1,0,13257213)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c13257213.condition)
	e1:SetTarget(c13257213.target)
	e1:SetOperation(c13257213.operation)
	c:RegisterEffect(e1)
	--cannot normal summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c13257213.checkop)
	c:RegisterEffect(e4,0)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13257213,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c13257213.spcon)
	e5:SetTarget(c13257213.sptg)
	e5:SetOperation(c13257213.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13257213,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c13257213.destg)
	e6:SetOperation(c13257213.desop)
	c:RegisterEffect(e6)
	
end
function c13257213.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c13257213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13257213.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c13257213.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257213.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(11,0,aux.Stringid(g:GetFirst():GetCode(),4))
	end
end
function c13257213.chkfilter(c,tp)
	return c:IsSetCard(0x353) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c13257213.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c13257213.chkfilter,1,nil,tp) then
		e:GetHandler():RegisterFlagEffect(13257213,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c13257213.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(13257213)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c13257213.filter(c,e,tp)
	return c:IsSetCard(0x353) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257213.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13257213.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13257213.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257213.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local sc=g:GetFirst()
		Duel.Hint(11,0,aux.Stringid(sc:GetCode(),4))
		local tep=sc:GetControler()
		local mt=getmetatable(sc)
		if mt then
			local eflist=mt[sc]
			local i=1
			while eflist[i] do
				if eflist[i]=="deck_equip" then i=i+1 break end
				i=i+1
			end
			if eflist[i] then
				local PCe=eflist[i]
				local cost=PCe:GetCost()
				local target=PCe:GetTarget()
				local operation=PCe:GetOperation()
				Duel.ClearTargetCard()
				e:SetProperty(PCe:GetProperty())
				sc:CreateEffectRelation(PCe)
				if cost then cost(PCe,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(PCe,tep,eg,ep,ev,re,r,rp,1) end
				if operation then operation(PCe,tep,eg,ep,ev,re,r,rp) end
				sc:ReleaseEffectRelation(PCe)
			end
		end
	end
end
function c13257213.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c13257213.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Destroy(c,REASON_EFFECT) end
end
