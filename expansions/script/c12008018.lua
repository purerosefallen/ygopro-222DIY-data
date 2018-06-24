--漆黑的质点 波恋达斯
function c12008018.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c12008018.matfilter,1) 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c12008018.splimit)
	c:RegisterEffect(e0)  
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12008018.regcon)
	e1:SetOperation(c12008018.regop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008018,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12008018)
	e2:SetCondition(c12008018.thcon)
	e2:SetTarget(c12008018.thtg)
	e2:SetOperation(c12008018.tgop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12008018,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,12008118)
	e3:SetTarget(c12008018.destg)
	e3:SetOperation(c12008018.desop)
	c:RegisterEffect(e3)
	if not c12008018.global_check then
		c12008018.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c12008018.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c12008018.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local p1=false
	local p2=false
	if tc:IsType(TYPE_PENDULUM) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:GetHandler():IsLocation(LOCATION_PZONE)) then
	   Duel.RegisterFlagEffect(rp,12008018,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12008018.splimit(e,se,sp,st,spos,tgp)
	return bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK or Duel.GetFlagEffect(tgp,12008018)==0
end
function c12008018.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local c2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	if chk==0 then return c1 or c2 end
	local g=Group.CreateGroup()
	if c1 then g:AddCard(c1) end
	if c2 then g:AddCard(c2) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c12008018.ffilter(c)
	return c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c12008018.desop(e,tp,eg,ep,ev,re,r,rp)
	local c1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local c2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	local g=Group.CreateGroup()
	if c1 then g:AddCard(c1) end
	if c2 then g:AddCard(c2) end
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			Duel.Recover(tp,1000,REASON_EFFECT)
			local fg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c12008018.ffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
			if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12008018,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=fg:Select(tp,1,1,nil)
				Duel.SSet(tp,sg)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function c12008018.thcon(e)
	return e:GetHandler():GetSequence()<4
end
function c12008018.thfilter(c)
	return c:IsSetCard(0x2fb3) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c12008018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008018.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12008018.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12008018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12008018.matfilter(c)
	return c:IsLinkType(TYPE_PENDULUM) and c:IsLinkType(TYPE_TUNER) and Duel.GetFlagEffect(c:GetControler(),12008018)==0
end
function c12008018.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12008018.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c12008018.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12008018.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_PENDULUM) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:GetHandler():IsLocation(LOCATION_PZONE))
end
