--「02的一击」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010006
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local f1=function(rc)
		return rc:IsFacedown() or not rc:IsCode(65010001)
	end
	local f2=function(e,tp)
		return not Duel.IsExistingMatchingCard(f1,tp,LOCATION_MZONE,0,1,nil)
	end
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"rm,dam,sp","tg",f2,nil,cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 or chkc then return 
		rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,{Card.IsAbleToRemove,"rm",0,LOCATION_MZONE })
	end
	local tc=rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,{Card.IsAbleToRemove,"rm",0,LOCATION_MZONE }):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(cm.limit(tc))
end
function cm.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function cm.op(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	local atk=tc:GetAttack()/2
	Duel.Damage(tp,atk,REASON_EFFECT)
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	if Duel.GetLP(tp)==0 or Duel.GetLP(1-tp)==0 then return end
	local f=function(c2,e2,tp2)
		return c2:IsCode(65010001) and c2:IsCanBeSpecialSummoned(e2,0,tp2,false,false)
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(f,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,f,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		rssf.SpecialSummon(sg)
	end
end
