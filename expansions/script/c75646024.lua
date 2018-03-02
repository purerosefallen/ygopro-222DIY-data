--佐仓慈
function c75646024.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c75646024.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c75646024.sprcon)
	e3:SetOperation(c75646024.sprop)
	c:RegisterEffect(e3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x20008)
	e2:SetType(0x81)
	e2:SetProperty(0x10000)
	e2:SetCode(1102)
	e2:SetCountLimit(1,75646024)
	e2:SetTarget(c75646024.thtg)
	e2:SetOperation(c75646024.thop)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(0x1)
	e4:SetType(0x100)
	e4:SetCode(1002)
	e4:SetRange(0x4)
	e4:SetCountLimit(1,75646024+0x20000000)
	e4:SetTarget(c75646024.destg)
	e4:SetOperation(c75646024.desop)
	c:RegisterEffect(e4)
end
function c75646024.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c75646024.sprfilter1(c,tp,fc)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c75646024.sprfilter2,1,c,fc)
end
function c75646024.sprfilter2(c,fc)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsCanBeFusionMaterial(fc)
end
function c75646024.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,0x4)>-2
		and Duel.CheckReleaseGroup(tp,c75646024.sprfilter1,1,nil,tp,c)
end
function c75646024.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c75646024.sprfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c75646024.sprfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,0x40088)
end
function c75646024.thfilter(c)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsAbleToHand()
end
function c75646024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646024.thfilter,tp,0x1,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x1)
end
function c75646024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646024.thfilter,tp,0x1,0,1,1,nil)
	if g:GetCount()>0  then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),0x80)
end
function c75646024.filter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk) and c:IsDestructable()
end
function c75646024.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c75646024.filter,tp,0x4,0x4,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c75646024.filter,tp,0x4,0x4,c,c:GetAttack())
	Duel.SetOperationInfo(0,0x1,g,g:GetCount(),0,0)
end
function c75646024.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75646024.filter,tp,0x4,0x4,c,c:GetAttack())
	Duel.Destroy(g,0x40)
end