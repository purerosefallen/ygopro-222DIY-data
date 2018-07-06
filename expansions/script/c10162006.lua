--太古龙·诡谲龙
function c10162006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10162006.ffilter,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c10162006.sprcon)
	e3:SetOperation(c10162006.sprop)
	c:RegisterEffect(e3)	
	--dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10162006,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c10162006.tdcost)
	e5:SetTarget(c10162006.tdtg)
	e5:SetOperation(c10162006.tdop)
	e5:SetCountLimit(1,10162006)
	c:RegisterEffect(e5) 
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c10162006.antarget)
	c:RegisterEffect(e6)  
end
function c10162006.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x9333) and (not sg or sg:IsExists(Card.IsFusionAttribute,1,nil,c:GetFusionAttribute()))
end
function c10162006.antarget(e,c)
	return c~=e:GetHandler()
end
function c10162006.tdop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local g=Duel.SelectMatchingCard(tp,c10162006.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
		if g:GetCount()>0 then
		   Duel.HintSelection(g)
		   if g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
			   Duel.NegateEffect(0)
			   return
		   end
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
				 local e1=Effect.CreateEffect(c)
				 e1:SetType(EFFECT_TYPE_SINGLE)
				 e1:SetCode(EFFECT_UPDATE_ATTACK)
				 e1:SetReset(RESET_EVENT+0x1fe0000)
				 e1:SetValue(math.floor(g:GetFirst():GetBaseAttack()))
				 c:RegisterEffect(e1)
			end
		end
end
function c10162006.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10162006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10162006.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_MZONE+LOCATION_GRAVE)
end
function c10162006.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10162006.matfilter(c,fc)
	return c:IsFusionSetCard(0x9333)
		and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c10162006.spfilter1(c,tp,g)
	return g:IsExists(c10162006.spfilter2,1,c,tp,c)
end
function c10162006.spfilter2(c,tp,mc)
	return c:GetRace()==mc:GetRace()
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c10162006.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10162006.matfilter,tp,LOCATION_MZONE,0,nil,c)
	return g:IsExists(c10162006.spfilter1,1,nil,tp,g)
end
function c10162006.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c10162006.matfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c10162006.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c10162006.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end