--3色翠神，波恋达斯
function c12008008.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x1fb3),2,99,c12008008.lcheck)
	c:EnableReviveLimit()
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2) 
	--Atk update
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c12008008.condition)
	e3:SetValue(c12008008.atkval)
	c:RegisterEffect(e3)  
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c12008008.econ)
	e4:SetValue(c12008008.efilter)
	c:RegisterEffect(e4) 
	--des
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(48964966,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c12008008.cost)
	e5:SetTarget(c12008008.target)
	e5:SetOperation(c12008008.operation)
	c:RegisterEffect(e5)
end
function c12008008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(0)<Duel.GetLP(1)
end
function c12008008.filter(c,lp)
	return c:IsFacedown() or (c:IsFaceup() and c:GetAttack()>0 and c:GetAttack()<=lp)
end
function c12008008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp1,lp2=Duel.GetLP(tp),Duel.GetLP(1-tp)
	local g=Duel.GetMatchingGroup(c12008008.filter,tp,0,LOCATION_MZONE,nil,lp1-lp2)
	if chk==0 then return lp1>lp2 and Duel.CheckLPCost(tp,lp1-lp2) and  g:GetCount()>0 end
	Duel.PayLPCost(tp,lp1-lp2)
	e:SetLabel(lp1-lp2)
end
function c12008008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function c12008008.operation(e,tp,eg,ep,ev,re,r,rp)
	local lp=e:GetLabel()
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
	local dg=Group.CreateGroup()
	for i=1,99 do
	   local g2=Duel.GetMatchingGroup(c12008008.filter2,tp,0,LOCATION_MZONE,dg,lp,dg)
	   if g2:GetCount()<=0 or (i>1 and not Duel.SelectYesNo(tp,aux.Stringid(12008008,1))) then break end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   local tc=g2:Select(tp,1,1,nil):GetFirst()
	   dg:AddCard(tc)
	end
	if dg:GetCount()>0 then
	   Duel.HintSelection(dg)
	end
	dg:Merge(g1)
	local ss=Duel.Destroy(dg,REASON_EFFECT)
	Duel.Recover(1-tp,ss*1000,REASON_EFFECT)
end
function c12008008.filter2(c,lp,dg)
	local sum=0
	if dg and dg:GetCount()>0 then
	   sum=dg:GetSum(Card.GetAttack)
	end
	return c:IsFaceup() and c:GetAttack()>0 and c:GetAttack()+sum<=lp
end
function c12008008.econ(e)
	return e:GetHandler():GetAttack()>e:GetHandler():GetBaseAttack()
end
function c12008008.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12008008.atkval(e,c)
	local tp=c:GetControler()
	local lp1,lp2=Duel.GetLP(tp),Duel.GetLP(1-tp)
	return math.abs(lp1-lp2)
end
function c12008008.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
