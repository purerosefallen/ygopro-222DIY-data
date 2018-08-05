--卡里莫拉
function c12009046.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c12009046.LinkCondition(aux.TRUE,2,2,c12009046.gf))
	e1:SetTarget(c12009046.LinkTarget(aux.TRUE,2,2,c12009046.gf))
	e1:SetOperation(aux.LinkOperation(aux.TRUE,2,2,c12009046.gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--td
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12009046,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12009046)
	e2:SetTarget(c12009046.tdtg)
	e2:SetOperation(c12009046.tdop)
	c:RegisterEffect(e2)
	--to h
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12009046,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetCountLimit(1)
	e3:SetTarget(c12009046.thtg)
	e3:SetOperation(c12009046.thop)
	c:RegisterEffect(e3)
end
function c12009046.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12009046.thfilter,tp,0xc,0xc,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,0xc)
end
function c12009046.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c12009046.thfilter,tp,0xc,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c12009046.thfilter(c)
   return c:IsFacedown() and c:IsAbleToHand()
end
function c12009046.filter1(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and Duel.IsExistingTarget(c12009046.filter2,tp,LOCATION_GRAVE,0,1,nil,c)
end
function c12009046.filter2(c,mc)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c12009046.isfit(c,mc)
end
function c12009046.isfit(c,mc)
	return mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))
end
function c12009046.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c12009046.filter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c12009046.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c12009046.filter2,tp,LOCATION_GRAVE,0,1,1,nil,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c12009046.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()<=0 or Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)<=0 then return end
	Duel.ShuffleDeck(tp)
	if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c12009046.acfilter),tp,LOCATION_GRAVE,0,1,nil,tp) or  Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(12009046,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12009046,2))
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12009046.acfilter),tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.ClearTargetCard()
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	tc:CancelToGrave(false)
	tc:CreateEffectRelation(te)
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and g:GetCount()>0 then
	   local tg=g:GetFirst()
	   while tg do
			 tg:CreateEffectRelation(te)
	   tg=g:GetNext()
	   end
	end
	tc:SetStatus(STATUS_ACTIVATED,true)
	if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if g and g:GetCount()>0 then
	   tg=g:GetFirst()
	   while tg do
			 tg:ReleaseEffectRelation(te)
	   tg=g:GetNext()
	   end
	end
	Duel.RegisterFlagEffect(tp,tc:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
	Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
end
function c12009046.acfilter(c,tp)
	return  (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_SPELL+TYPE_RITUAL) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c12009046.gf(g,lc)
	return g:IsExists(Card.IsFacedown,1,nil)
end
function c12009046.LinkCondition(f,minc,maxc,gf)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local f=Card.IsFaceup
				Card.IsFaceup=aux.TRUE
				local tp=c:GetControler()
				local mg=Auxiliary.GetLinkMaterials(tp,f,c)
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then Card.IsFaceup=f return false end
				local ct=sg:GetCount()
				if ct>maxc then Card.IsFaceup=f return false end
				if Auxiliary.LCheckGoal(tp,sg,c,minc,ct,gf)
					or mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,c,ct,minc,maxc,gf) then Card.IsFaceup=f return true end
				return false
			end
end
function c12009046.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local f=Card.IsFaceup
				Card.IsFaceup=aux.TRUE
				local mg=Auxiliary.GetLinkMaterials(tp,f,c)
				local bg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if #bg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					bg:Select(tp,#bg,#bg,nil)
				end
				local sg=Group.CreateGroup()
				sg:Merge(bg)
				local finish=false
				while #sg<maxc do
					finish=Auxiliary.LCheckGoal(tp,sg,c,minc,#sg,gf)
					local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,#sg,minc,maxc,gf)
					if #cg==0 then break end
					local cancel=not finish
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local tc=cg:SelectUnselect(sg,tp,finish,cancel,minc,maxc)
					if not tc then break end
					if not bg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
							if #sg==maxc then finish=true end
						else
							sg:RemoveCard(tc)
						end
					elseif #bg>0 and #sg<=#bg then
						Card.IsFaceup=f
						return false
					end
				end
				Card.IsFaceup=f
				if finish then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
