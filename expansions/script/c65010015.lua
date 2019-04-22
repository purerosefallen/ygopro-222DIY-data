--深层之因帕克特
function c65010015.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65010015.sprcon)
	e0:SetOperation(c65010015.sprop)
	c:RegisterEffect(e0)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c65010015.accon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--impact
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65010015.con)
	e3:SetTarget(c65010015.tg)
	e3:SetOperation(c65010015.op)
	c:RegisterEffect(e3)
end
function c65010015.accon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end


function c65010015.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
		 and rp==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsStatus(STATUS_ACT_FROM_HAND)
end
function c65010015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t=Duel.IsChainNegatable(ev)
	local op=0
	if t then 
		op=Duel.SelectOption(tp,aux.Stringid(65010015,0),aux.Stringid(65010015,1)) 
	else 
		op=Duel.SelectOption(tp,aux.Stringid(65010015,1))
	end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65010015,op))
	if op==0 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function c65010015.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		if Duel.NegateActivation(ev) then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	elseif op==1 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c65010015.repop)
	end
end
function c65010015.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c65010015.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c65010015.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65010015.sprfilter2,1,c,tp,c,sc,lv)
end
function c65010015.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:GetLevel()==lv-7 and c:GetOriginalLevel()>0 and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65010015.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65010015.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65010015.sprfilter1,1,nil,tp,g,c)
end
function c65010015.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65010015.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65010015.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65010015.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end